package com.caipeiyan.crm.workbench.mapper;

import com.caipeiyan.crm.workbench.pojo.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Sun May 08 21:10:53 CST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Sun May 08 21:10:53 CST 2022
     */
    int insert(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Sun May 08 21:10:53 CST 2022
     */
    int insertSelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Sun May 08 21:10:53 CST 2022
     */
    Activity selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Sun May 08 21:10:53 CST 2022
     */
    int updateByPrimaryKeySelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Sun May 08 21:10:53 CST 2022
     */
    int updateByPrimaryKey(Activity record);

    /**
     * 创建activity活动
     * @param activity
     * @return
     */
    int insertActivity(Activity activity);

    /**
     * 在分页和有条件的情况下，查询活动
     * @param map
     * @return
     */
    List<Activity> selectActivityByConditionForPage(Map<String,Object> map);

    /**
     * 查询符合条件的活动数量
     * @param map
     * @return
     */
    int selectAmountOfActivity(Map<String,Object> map);

    /**
     * 根据id来删除活动
     * @param ids
     * @return
     */
    int deleteActivityById(String[] ids);

    /**
     * 根据id来查询活动信息
     * @param id
     * @return
     */
    Activity selectActivityById(String id);

    /**
     * 根据id来更新活动
     * @param activity
     * @return
     */
    int updateActivity(Activity activity);
}
